<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty success}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            mostrarExito('Operación exitosa', decodeURIComponent('<c:out value="${success}" />'));
            limpiarParametrosURL();
        });
    </script>
</c:if>

<c:if test="${not empty error}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            mostrarError('Error', decodeURIComponent('<c:out value="${error}" />'));
            limpiarParametrosURL();
        });
    </script>
</c:if>

<c:if test="${not empty warning}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            mostrarAdvertencia('Advertencia', decodeURIComponent('<c:out value="${warning}" />'));
            limpiarParametrosURL();
        });
    </script>
</c:if>

<c:if test="${not empty info}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            mostrarToast('info', decodeURIComponent('<c:out value="${info}" />'));
            limpiarParametrosURL();
        });
    </script>
</c:if>