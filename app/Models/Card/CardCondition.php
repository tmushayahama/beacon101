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
 protected $table = 'mt_card_condition';

 public function card() {
  return $this->belongsTo('App\Models\Card\CardQuestion', 'card_id');
 }

 public function parentCard() {
  return $this->belongsTo('App\Models\Card\CardQuestion', 'parent_card_id');
 }

 public function creator() {
  return $this->belongsTo('App\Models\User\User', 'creator_id');
 }

 public function type() {
  return $this->belongsTo('App\Models\Level\Level', 'type_id');
 }

 public function status() {
  return $this->belongsTo('App\Models\Level\Level', 'status_id');
 }

 /**
  * The attributes that are mass assignable.
  *
  * @var array
  */
 protected $fillable = [];

 public static function createCardCondition($cardId, $conditionalIds) {
  foreach ($conditionalIds as $conditionalId) {
   $cardCondition = new CardQuestion();
   $cardCondition->creator_id = 2;
   $cardCondition->card_id = $cardId;
   $cardCondition->parent_card_id = $conditionalId;

   DB::beginTransaction();
   try {
    $cardCondition->save();
   } catch (\Exception $e) {
    DB::rollback();
    throw $e;
   }
   DB::commit();
  }

  return true;
 }

}
