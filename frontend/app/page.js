export const dynamic = 'force-dynamic';
export default async function Home() {
  let tasks = [], error = false;
  try {
    const response = await fetch(`${process.env.API_URL}/api/tasks`, { cache: 'no-store', signal: AbortSignal.timeout(5000) });
    if (!response.ok) throw new Error('API unavailable');
    tasks = await response.json();
  } catch { error = true; }
  return <main><small>DEVOPS / MULTI-STAGE BUILDS</small><h1>Taskboard</h1><p>Next.js → Nginx → Laravel → MySQL</p>
    {error ? <p role="alert">No se pudo conectar con la API. Comprueba el estado de los contenedores.</p> : <><p>{tasks.length} tareas guardadas en MySQL</p><ul>{tasks.map(task => <li key={task.id}><span>{task.completed ? '✓' : '○'}</span> {task.title}</li>)}</ul></>}
    <footer>Imágenes pequeñas. Capas reutilizables. Datos persistentes.</footer></main>;
}
