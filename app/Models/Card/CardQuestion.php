<?php

namespace App\Models\Card;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Collection;
use App\Models\Level\Level;
use Request;
use DB;
use JWTAuth;

class CardQuestion extends Model {

 /**
  * The database table used by the model.
  *
  * @var string
  */
 protected $table = 'mt_card_question';
 public static $RELATIONSHIP = array(
     "siblings" => 1,
     "children" => 2,
 );

 public function card() {
  return $this->belongsTo('App\Models\Card\Card', 'card_id');
 }

 public function parentCard() {
  return $this->belongsTo('App\Models\Card\Card', 'parent_card_id');
 }

 public function creator() {
  return $this->belongsTo('App\Models\User\User', 'creator_id');
 }

 public function type() {
  return $this->belongsTo('App\Models\Level\Level', 'type_id');
 }

 public function level() {
  return $this->belongsTo('App\Models\Level\Level', 'level_id');
 }

 public function status() {
  return $this->belongsTo('App\Models\Level\Level', 'status_id');
 }

 /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
 protected $fillable = ['description'];

 /**
  * Get Questions
  *
  * @return type
  */
 public static function getCardQuestions() {
  $parentCardId = Request::get("cardId");
  $direction = Request::get("direction");
  $card = [];
  if (!$parentCardId) {
   $card = CardQuestion::inRandomOrder()
           ->with('card')
           ->with('creator')
           ->first();
  } else {
   $card = self::getCardQuestionByDirection($parentCardId, $direction);
  }

  $cards = self::getCardSiblings($card);

  return $cards;
 }

 public static function getCardQuestion() {
  $cardId = Request::get("cardId");
  $typeId = Request::get("typeId");
  $relation = Request::get("relatives");

  // case Level::$level_categories["responseType"]['singleChoice']:
  // case Level::$level_categories["responseType"]['multipleChoice']:


  $cardQuestion = [];
  if ($cardId) {
   $cardQuestion = CardQuestion
           ::with(['creator', 'card', 'parentCard'])
           ->find($cardId);
  } else {
   $cardQuestion = CardQuestion//::inRandomOrder()
           // ::where('type_id', $typeId)
           ::with(['creator', 'card'])
           //->first();
           ->find(11185);
   //$card = self::getCardQuestionByDirection($cardId, $direction);
  }

  if (($relation & self::$RELATIONSHIP["siblings"]) == self::$RELATIONSHIP["siblings"]) {
   $cardQuestion["siblings"] = self::getCardSiblings($cardQuestion->parent_card_id);
  }

  if (($relation & self::$RELATIONSHIP["children"]) == self::$RELATIONSHIP["children"]) {
   $cardQuestion["children"] = self::getCardChildrenByCode($cardQuestion->card_id);
  }

  $cardQuestion['stats'] = array();
  $cardQuestion["childrenCount"] = self::getCardChildrenCount($cardQuestion->card_id);
  $cardQuestion["hasChildren"] = $cardQuestion["childrenCount"] > 0;

  return $cardQuestion;
 }

 public static function getCardQuestionParent($parentCardId) {
  $relation = Request::get("relatives");

  $cardQuestion = CardQuestion::where('card_id', $parentCardId)
          ->with(['creator', 'card', 'parentCard'])
          ->first();

  if (($relation & self::$RELATIONSHIP["siblings"]) == self::$RELATIONSHIP["siblings"]) {
   $cardQuestion["siblings"] = self::getCardSiblings($cardQuestion->parent_card_id);
  }

  if (($relation & self::$RELATIONSHIP["children"]) == self::$RELATIONSHIP["children"]) {
   $cardQuestion["children"] = self::getCardChildrenByCode($cardQuestion->card_id);
  }

  $cardQuestion['stats'] = array();
  $cardQuestion["childrenCount"] = self::getCardChildrenCount($cardQuestion->id);
  $cardQuestion["hasChildren"] = $cardQuestion["childrenCount"] > 0;

  return $cardQuestion;
 }

 /**
  * Creates a question for the card
  *
  */
 public static function createCardQuestion() {

  $cardQuestion = new CardQuestion();
  $cardQuestion->creator_id = 2;
  $cardQuestion->response_type_id = Request::get("responseType");
  $cardQuestion->type_id = Request::get("category");
  //$cardQuestion->privacy_id = Level::$level_categories["privacy"]["public"];
  $cardQuestion->parent_card_id = Request::get("parentCardId");
  $conditionalIds = Request::get("conditionalIds");

  DB::beginTransaction();
  try {
   $card = Card::createCard();
   $cardQuestion->card_id = $card->id;
   if ($conditionalIds) {
    self::createCardChildren($cardQuestion, $conditionalIds);
   } else {
    $cardQuestion->save();
   }
  } catch (\Exception $e) {
   DB::rollback();
   throw $e;
  }
  DB::commit();
  return $cardQuestion;
 }

 public static function updateCardQuestion($cardId) {
  $cardQuestion = CardQuestion::find($cardId);

  try {
   $cardQuestion->parent_card_id = Request::get("parentCardId");
   DB::beginTransaction();
   $cardQuestion->save();
  } catch (\Exception $e) {
   DB::rollback();
   throw $e;
  }
  DB::commit();
  return $cardQuestion;
 }

 public static function getQuestionStats($userId) {
  $questionsCount = CardQuestion::where('contributor_id', $userId)
          ->count();
  return array('totalCount' => $questionsCount);
 }

 private static function getCardQuestionByDirection($parentCardId, $direction) {
  switch ($direction) {
   case Level::$DIRECTION["east"]:
    $card = CardQuestion::inRandomOrder()
            ->with(['card', 'creator'])
            ->first();
  }
  return $card;
 }

 public static function getCardSiblings($cardId) {
  $cards = CardQuestion::where(function ($q) use($cardId) {
           if ($cardId) {
            $q->where('parent_card_id', $cardId);
           } else {
            $q->whereNull('parent_card_id');
           }
          })
          ->with(['creator', 'card'])
          ->limit(25)
          ->get();

  return $cards;
 }

 public static function getCardChildren($cardId) {
  $cards = CardQuestion::orderBy('importance', 'desc')
          ->where('parent_card_id', $cardId)
          ->with('card')
          ->get();

  foreach ($cards as $card) {
   $card["childrenCount"] = self::getCardChildrenCount($card->card_id);
   $card["hasChildren"] = $card["childrenCount"] > 0;
  }

  return $cards;
 }

 public static function getCardChildrenByCode($cardId) {
  $cards = array();

  $cardTypes = Level::getSubLevels(Level::$level_categories['apps']);
  foreach ($cardTypes as $cardType) {
   $cards[$cardType->code] = $cardType;
   $cards[$cardType->code]["cards"] = self::getCardsByType($cardId, $cardType->id);
  }

  return $cards;
 }

 public static function getCardsByType($cardId, $typeId, $page = 0) {
  $query = CardQuestion::orderBy('importance', 'desc')
          ->where('type_id', $typeId)
          ->with(['creator', 'card', 'type'])
          ->offset($page * 20)
          ->take(20);
  if ($cardId) {
   $query->where('parent_card_id', $cardId);
  }

  $cards = $query->get();

  return $cards;
 }

 public static function getCardChildrenCount($cardId) {
  $count = CardQuestion::where('parent_card_id', $cardId)->count();

  return $count;
 }

 public static function createCardChildren($parentCardQuestion, $parentIds) {
  foreach ($parentIds as $conditionalId) {
   $cardQuestion = $parentCardQuestion->replicate();
   $cardQuestion->parent_card_id = $conditionalId;

   DB::beginTransaction();
   try {
    $cardQuestion->save();
   } catch (\Exception $e) {
    DB::rollback();
    throw $e;
   }
   DB::commit();
  }

  return true;
 }

}
