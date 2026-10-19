# Validación realizada

Fecha local: 18 de octubre de 2026. Docker Desktop / Engine 20.10.20, Compose 2.12.1, Linux amd64.

- `docker compose config --quiet`: correcto, usando un `.env` local excluido de Git.
- Builds de los targets Laravel, Nginx y Next.js: correctos.
- Next.js resuelto por lockfile: 16.4.2; build de producción con App Router correcto.
- Laravel resuelto por lockfile: 12.70.0; Composer instala dependencias en PHP 8.2 sin ignorar requisitos de plataforma durante el build.
- Extensiones verificadas en runtime: pdo_mysql, mbstring, openssl, tokenizer, xml, ctype y json.
- Migraciones aplicadas correctamente en MySQL 8.0.
- `scripts/smoke.ps1`: correcto; salud con consulta SQL, creación 201, actualización, respuesta 422 para título vacío y HTML de Next.js mostrando la tarea almacenada. Se elimina la tarea al terminar.
- Persistencia: una tarea creada antes de `docker compose down` seguía disponible después de `docker compose up -d`. Se eliminó el registro de prueba.
- Reconstrucción del frontend: las etapas de dependencias mostraron `CACHED`.
- MySQL no publica puertos al host. Nginx y Next.js se vinculan a 127.0.0.1.
- Repositorio GitHub confirmado público mediante su API, sin credenciales.

Tamaños locales sin comprimir obtenidos mediante `docker compose images`:

| Imagen | Tamaño |
| --- | --- |
| Frontend Next.js | 624 MB |
| Backend Laravel / FPM | 114 MB |
| Nginx | 60,2 MB |
| MySQL oficial | 799 MB |

El frontend conserva Next.js y sus dependencias completas para cumplir el arranque exigido con `next start`. La caché `.next/cache` se elimina del build final. El modo standalone permitiría otra estrategia más pequeña con `node server.js`, pero cambiaría el comando solicitado. No se midió una imagen monolítica anterior, por lo que no se atribuye una reducción porcentual.

La prueba se ejecutó mediante IPv4 directo y sin proxy en PowerShell 7, porque la configuración de proxy del host interfería con solicitudes locales. El script adapta ese ajuste a PowerShell 7.

Limitación de la entrega: se creó una aplicación de referencia porque no había proyectos previos del bootcamp en esta carpeta. La sustitución por esas aplicaciones, si es exigida, sigue dependiendo de disponer de sus fuentes.
