<?php

namespace App\Models\Card;

use Illuminate\Support\Collection;
use Illuminate\Database\Eloquent\Model;
use App\Models\Card\CardQuestion;
use App\Models\Level\Level;
use Request;
use DB;
use JWTAuth;

/**
 * This is a SkillSection's card model. A card is a base of every card found in
 * SkillSection.
 * Follwing is list of cards derived from Card. They have shared properties This has helped
 * to reduce the number database tables and simplified it.
 *
 * - Note
 * - Guideline
 * - Activity
 * - Step
 * - Question
 * - Checklist Item
 * - Weblink Item
 * - Todo Item
 * - Skill
 * - Goals
 * - Hobby
 * - Promise
 * - Collaboration
 * - Teach
 * - Advice
 * - Group
 * - Journal
 * - Page
 * - Project
 *
 */
class Card extends Model {

 /**
  * The database table used by the model mt_card.
  *
  * @var string
  */
 protected $table = 'mt_card';

 /**
  * The default value for a newly created card
  *
  * var string
  */
 const DEFAULT_PICTURE_URL = 'default.png';

 /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
 protected $fillable = ['title', 'description'];

 /**
  * Defines the creator's many to one relationship with a card
  *
  * @return type creator relationship
  */
 public function creator() {
  return $this->belongsTo('App\Models\User\User', 'creator_id');
 }

 /**
  * Defines the creator's many to one relationship with it's parent card
  *
  * @return type creator relationship
  */
 public function parentCard() {
  return $this->belongsTo('App\Models\Card\Card', 'parent_card_id');
 }

 /**
  * Defines the level type's many to one relationship with a card
  *
  * @return type level type relationship
  */
 public function type() {
  return $this->belongsTo('App\Models\Level\Level', 'type_id');
 }

 /**
  * Create a new card with a minimum of the following request params
  * title
  * description
  * type
  *
  * @return type a newly created card with limited data because it is redirected to the new page
  */
 public static function createCard() {

  $card = new Card;
  $card->creator_id = 2;
  $card->type_id = Request::get("category");
  $card->title = Request::get("title");
  $card->description = Request::get('description');
  $card->card_picture_url = Card::DEFAULT_PICTURE_URL;

  DB::beginTransaction();
  try {
   $card->save();
  } catch (\Exception $e) {
   //failed logic here
   DB::rollback();
   throw $e;
  }
  DB::commit();
  return $card;
 }

 /**
  * Get user cards by type with their subcards recursively.
  *
  * @param userId the creator of the card
  * @param type $typeId type of a the card
  * @return cards collection
  */
 public static function getUserCardsByType($userId, $typeId) {
  $cards = Card::orderBy('order', 'desc')
          ->where('type_id', $typeId)
          ->where('creator_id', $userId)
          ->with("parentCard")
          ->with('creator')
          ->take(20)
          ->get();
  return $cards;
 }

 public static function getCard() {
  $card = Card::inRandomOrder()->first();

  return $card;
 }

 /**
  * Keyword search querybuilder
  *
  * @param type $query
  * @param type $keyword
  * @return type
  */
 public function scopeSearchByKeyword($query, $keyword) {
  if ($keyword != '') {
   $query->where(function ($query) use ($keyword) {
    $query->where("title", "LIKE", "%$keyword%")
            ->orWhere("description", "LIKE", "%$keyword%");
   });
  }
  return $query;
 }

}
