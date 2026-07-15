<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\KitController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\CategoryController;

Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:5,15');
Route::post('/login',    [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me',      [AuthController::class, 'me']);

    Route::apiResource('kits', KitController::class);

    Route::get('/kits/{kit_id}/items', [ItemController::class, 'index']);
    Route::post('/kits/{kit_id}/items', [ItemController::class, 'store']);
    Route::put('/kits/{kit_id}/items/{id}', [ItemController::class, 'update']);
    Route::delete('/kits/{kit_id}/items/{id}', [ItemController::class, 'destroy']);
    Route::patch('/kits/{kit_id}/items/{id}/toggle', [ItemController::class, 'toggle']);

    Route::apiResource('categories', CategoryController::class);
});
