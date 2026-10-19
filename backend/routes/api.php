<?php

use App\Http\Controllers\TaskController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::get('/health', function () {
    DB::select('SELECT 1');
    return response()->json(['status' => 'ok', 'database' => 'connected']);
});
Route::apiResource('tasks', TaskController::class);
