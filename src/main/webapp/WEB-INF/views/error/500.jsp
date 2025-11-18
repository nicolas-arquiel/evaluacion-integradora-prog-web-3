<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Error 500 - Error interno</title>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    <link rel="stylesheet" href="/css/error.css">
</head>

<body>

<jsp:include page="/WEB-INF/includes/sidebar.jsp" />

<div class="content">

    <div class="error-container">
        <h1>500</h1>
        <p>Ocurrió un error inesperado en el servidor.</p>

        <a href="/app/inicio" class="btn btn-primary">Volver al inicio</a>
    </div>

</div>

</body>
</html>
