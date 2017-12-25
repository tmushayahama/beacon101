<?php

use Illuminate\Http\Request;

/*
  |--------------------------------------------------------------------------
  | API Routes
  |--------------------------------------------------------------------------
  |
  | Here is where you can register API routes for your application. These
  | routes are loaded by the RouteServiceProvider within a group which
  | is assigned the "api" middleware group. Enjoy building your API!
  |
 */
Route::get('/', function () {
 return view('index');
});

Route::middleware('auth:api')->get('/user', function (Request $request) {
 return $request->user();
});

//Auth
Route::resource('authenticate', 'AuthenticateController', ['only' => ['index']]);
Route::post('authenticate', 'AuthenticateController@authenticate');
Route::post('register', 'AuthenticateController@register');
Route::post('user/invite', 'AuthenticateController@invite');
Route::get('logout', 'AuthenticateController@logout');
Route::get('authenticate/user', 'AuthenticateController@getAuthenticatedUser');
//Settings and Constants
Route::get('categories', 'Config\ConfigController@getCategories');
//Card
Route::get('cards', 'Card\CardController@getCardQuestion');
Route::get('cards/{cardId}/children', 'Card\CardController@getCardChildren');
Route::get('cards/{cardId}/parent', 'Card\CardController@getCardQuestionParent');
Route::post('cards', 'Card\CardController@createCardQuestion');
Route::patch('cards/{cardId}', 'Card\CardController@updateCardQuestion');
