<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Obras Sociales - Salud Total</title>
            <jsp:include page="/WEB-INF/includes/header.jsp" />
            <script src="/js/obrasocial.js"></script>
        </head>

        <body>

            <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

            <div class="content">
                <h2><i class="fas fa-hospital"></i> Obras Sociales</h2>

                <button class="btn btn-primary" onclick="abrirNuevo()">
                    <i class="fas fa-plus"></i> Nueva Obra Social
                </button>

                <br><br>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>

                    <c:forEach var="o" items="${items}">
                        <tr>
                            <td>${o.id}</td>
                            <td>${o.nombre}</td>

                            <td>
                                <button class="btn btn-primary" onclick="abrirEditar('${o.id}','${o.nombre}')">
                                    <i class="fas fa-edit"></i> Editar
                                </button>

                                <button class="btn btn-danger" onclick="eliminarObraSocial('${o.id}')">
                                    <i class="fas fa-trash"></i> Eliminar
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <dialog id="modalForm">
                <h3 id="modalTitle"></h3>

                <form method="post" action="/app/obras-sociales">
                    <input type="hidden" id="form-action" name="action">
                    <input type="hidden" id="form-id" name="id">

                    <label><i class="fas fa-hospital"></i> Nombre:</label>
                    <input type="text" id="form-nombre" name="nombre" required>

                    <br>
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-save"></i> Guardar
                    </button>

                    <button type="button" class="btn" onclick="modalForm.close()">
                        <i class="fas fa-times"></i> Cancelar
                    </button>
                </form>
            </dialog>

            <jsp:include page="/WEB-INF/includes/alerts.jsp" />

        </body>

        </html>