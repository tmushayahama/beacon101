<?php

namespace App\Http\Controllers\Config;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Level\Level;

class ConfigController extends Controller {

 public function getCategories() {
  $result = Level::getCategories();
  return response()->json($result, 200);
 }

 public function getComponentTypes() {
  return \Response::json(Level::getComponentTypes());
 }

 public function getSubLevels($category) {
  return \Response::json(Level::getSubLevels($category));
 }

}
