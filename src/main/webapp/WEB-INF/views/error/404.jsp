<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Error 404 - Página no encontrada</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <link rel="stylesheet" href="/css/error.css">
</head>

<body>

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="content">

    <div class="error-container">
        <h1>404</h1>
        <p>La página que buscás no existe.</p>

        <a href="/app/inicio" class="btn btn-primary">Volver al inicio</a>
    </div>

</div>

</body>
</html>
