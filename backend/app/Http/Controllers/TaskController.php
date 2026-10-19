<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index() { return Task::orderByDesc('id')->get(); }
    public function show(Task $task) { return $task; }
    public function store(Request $request)
    {
        return response()->json(Task::create($request->validate([
            'title' => 'required|string|max:255', 'completed' => 'sometimes|boolean',
        ])), 201);
    }
    public function update(Request $request, Task $task)
    {
        $task->update($request->validate([
            'title' => 'sometimes|required|string|max:255', 'completed' => 'sometimes|boolean',
        ]));
        return $task->refresh();
    }
    public function destroy(Task $task)
    {
        $task->delete();
        return response()->noContent();
    }
}
