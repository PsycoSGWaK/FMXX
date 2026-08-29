document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.alert.alert-dismissible.show').forEach(function (el) {
        setTimeout(function () {
            var instance = bootstrap.Alert.getOrCreateInstance(el);
            instance.close();
        }, 5000);
    });
});
