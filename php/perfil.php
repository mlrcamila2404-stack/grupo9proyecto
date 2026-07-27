<?php
require 'auth-check.php';
require 'db.php';
 
$stmt = $pdo->prepare("SELECT * FROM usuarios WHERE id_usuario = ?");
$stmt->execute([$_SESSION['id_usuario']]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);
 
$iniciales = strtoupper(mb_substr($usuario['nombre'], 0, 1) . mb_substr($usuario['apellido'], 0, 1));
 
$stmtTotal = $pdo->prepare(
    "SELECT COUNT(*) AS total FROM intentos WHERE id_usuario = ? AND fecha_fin IS NOT NULL"
);
$stmtTotal->execute([$_SESSION['id_usuario']]);
$totalExamenes = $stmtTotal->fetch(PDO::FETCH_ASSOC)['total'];
 
$stmtProm = $pdo->prepare(
    "SELECT AVG(porcentaje) AS promedio FROM intentos WHERE id_usuario = ? AND fecha_fin IS NOT NULL"
);
$stmtProm->execute([$_SESSION['id_usuario']]);
$promedioRaw = $stmtProm->fetch(PDO::FETCH_ASSOC)['promedio'];
$promedio = $promedioRaw !== null ? round($promedioRaw) : 0;
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Practify - Perfil</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/perfil.css" rel="stylesheet">
</head>
<body>
 
  <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
    <div class="container">
      <a class="navbar-brand wordmark-nav" href="home.html"><span class="w-blue">Pract</span><span class="w-purple">ify</span></a>
      <div class="collapse navbar-collapse">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="examenes.html">Exámenes</a></li>
          <li class="nav-item"><a class="nav-link" href="resultados.html">Resultados</a></li>
          <li class="nav-item"><a class="nav-link" href="progreso.php">Progreso</a></li>
          <li class="nav-item"><a class="nav-link active" href="perfil.php">Perfil</a></li>
        </ul>
      </div>
    </div>
  </nav>
 
  <div class="container page-header pb-5">
 
    <div class="panel mb-4 d-flex flex-wrap align-items-center gap-3 justify-content-between">
      <div class="d-flex align-items-center gap-3">
        <div class="avatar-circle"><?= htmlspecialchars($iniciales) ?></div>
        <div>
          <h4 class="mb-0 fw-bold"><?= htmlspecialchars($usuario['nombre'] . ' ' . $usuario['apellido']) ?></h4>
          <div class="text-muted small"><?= htmlspecialchars($usuario['correo']) ?></div>
        </div>
      </div>
      <div class="d-flex gap-2">
        <button class="btn-practfy" type="button" data-bs-toggle="collapse" data-bs-target="#editProfileForm" aria-expanded="false" aria-controls="editProfileForm">Editar perfil</button>
        <a href="logout.php" class="btn-outline-practfy">Cerrar sesión</a>
      </div>
    </div>
 
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-6">
        <div class="stat-card">
          <div class="value"><?= $totalExamenes ?></div>
          <div class="label">Exámenes completados</div>
        </div>
      </div>
      <div class="col-6 col-md-6">
        <div class="stat-card">
          <div class="value"><?= $promedio ?>%</div>
          <div class="label">Promedio general</div>
        </div>
      </div>
    </div>
 
    <div class="panel mb-4">
      <h5 class="fw-bold mb-3">Progreso general</h5>
 
      <div class="progress-hero mb-4">
        <div class="small fw-semibold">Progreso total</div>
        <div class="big-number"><?= $promedio ?>%</div>
        <div class="small">promedio de todos tus exámenes completados</div>
      </div>
 
      <?php if ($totalExamenes === 0): ?>
        <p class="text-muted small mb-0">Todavía no has completado ningún examen. ¡Empieza a practicar para ver tu progreso aquí!</p>
      <?php endif; ?>
    </div>
 
    <div class="collapse" id="editProfileForm">
      <div class="panel">
        <h5 class="fw-bold mb-3">Editar perfil</h5>
        <form action="perfil-actualizar.php" method="POST">
          <div class="row g-3">
            <div class="col-md-6 field">
              <label for="nombre">Nombre</label>
              <input type="text" id="nombre" name="nombre" class="form-control" value="<?= htmlspecialchars($usuario['nombre']) ?>">
            </div>
            <div class="col-md-6 field">
              <label for="apellido">Apellido</label>
              <input type="text" id="apellido" name="apellido" class="form-control" value="<?= htmlspecialchars($usuario['apellido']) ?>">
            </div>
            <div class="col-md-6 field">
              <label for="correo">Correo electrónico</label>
              <input type="email" id="correo" name="correo" class="form-control" value="<?= htmlspecialchars($usuario['correo']) ?>">
            </div>
            <div class="col-md-6 field">
              <label for="password">Nueva contraseña</label>
              <input type="password" id="password" name="password" class="form-control" placeholder="Dejar en blanco para no cambiar">
            </div>
          </div>
          <button type="submit" class="btn-practfy mt-4">Guardar cambios</button>
        </form>
      </div>
    </div>
 
  </div>
 
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
 
</body>
</html>
 