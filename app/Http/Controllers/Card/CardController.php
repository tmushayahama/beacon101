<?php

namespace App\Http\Controllers\Card;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Card\Card;
use App\Models\Card\CardQuestion;

/*
  |--------------------------------------------------------------------------
  | Explorer Controller
  |--------------------------------------------------------------------------
  |
  | This controller
  |
 */

class CardController extends Controller {

 /**
  * Create a new controller instance.
  *
  * @return void
  */
 public function __construct() {
  //$this->middleware('guest');
 }

 /**
  * Get a validator for an incoming registration request.
  *
  * @param  array  $data
  * @return \Illuminate\Contracts\Validation\Validator
  */
 protected function validator(array $data) {
  return Validator::make($data, [
              'name' => 'required|string|max:255',
              'email' => 'required|string|email|max:255|unique:users',
              'password' => 'required|string|min:6|confirmed',
  ]);
 }

 /**
  * Create a new user instance after a valid registration.
  *
  * @param  array  $data
  * @return \App\User
  */
 protected function create(array $data) {
  return User::create([
              'name' => $data['name'],
              'email' => $data['email'],
              'password' => bcrypt($data['password']),
  ]);
 }

 /**
  * Store a newly created resource in storage.
  *
  * @param  \Illuminate\Http\Request  $request
  * @return \Illuminate\Http\Response
  */
 public function store(Request $request) {
  $validator = Validator::make($request->all(), [
              'name' => 'required|max:60',
              'email' => 'required|email|unique:users',
              'telefone' => 'required|unique:users',
  ]);
  if ($validator->fails()) {
   return response([
       'message' => 'Validation Failed',
       'errors' => $validator->errors()->all()
   ]);
  }
  $user = new User();
  $user->fill($request->all());
  $user->save();
  return response($user, 201);
 }

 public function getCard($id) {
  $card = Card::getCard($id);

  return response()->json($card, 200);
 }

 public function getCardQuestion() {
  $cards = CardQuestion::getCardQuestion();

  return response()->json($cards, 200);
 }

 public function getCardQuestionParent($parentCardId) {
  $cards = CardQuestion::getCardQuestionParent($parentCardId);

  return response()->json($cards, 200);
 }

 public function getCardChildren($cardId) {
  $cards = CardQuestion::getCardChildren($cardId);

  return response()->json($cards, 200);
 }

 public function createCardQuestion(Request $request) {
  $validator = Validator::make($request->all(), [
              'title' => 'required',
  ]);

  if ($validator->fails()) {
   return response([
       'message' => 'Validation Failed',
       'errors' => $validator->errors()->all()
   ]);
  }

  $cardQuestion = CardQuestion::createCardQuestion();

  return response()->json($cardQuestion, 200);
 }

 public function updateCardQuestion($cardId) {
  $cardQuestion = CardQuestion::updateCardQuestion($cardId);

  return response()->json($cardQuestion, 200);
 }

 /**
  * Update the specified resource in storage.
  *
  * @param  \Illuminate\Http\Request  $request
  * @param  int  $id
  * @return \Illuminate\Http\Response
  */
 public function update(Request $request, $id) {
  $validator = Validator::make($request->all(), [
              'name' => 'required|max:60',
              'email' => 'required|email',
              'telefone' => 'required',
  ]);
  if ($validator->fails()) {
   return response([
       'message' => 'Validation Failed',
       'errors' => $validator->errors()->all()
   ]);
  }
  $user = User::find($id);
  if (!$user) {
   return response(array('message' => 'Record not found.'), 404);
  }
  $user->fill($request->all());
  $user->save();
  return response($user, 200);
 }

 /**
  * Remove the specified resource from storage.
  *
  * @param  int  $id
  * @return \Illuminate\Http\Response
  */
 public function destroy($id) {
  $user = User::find($id);
  if (!$user) {
   return response(array('message' => 'Record not found.'), 404);
  }
  $user->delete();
  return response(array('message' => 'Record was deleted.'), 200);
 }

}
