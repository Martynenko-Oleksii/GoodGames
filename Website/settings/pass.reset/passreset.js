//PRELOADER
window.onload = function () {
	document.body.classList.add('loaded_hiding');
	window.setTimeout(function () {
		document.body.classList.add('loaded');
		document.body.classList.remove('loaded_hiding');
	}, 500);
}

// ШАГ ПЕРВЫЙ. Отправка кода.
function send_code(){
    document.getElementById("error_email").textContent = "⠀"; // Физический пробел. Не трогать.

    var email = document.getElementById("email").value; // Почта

    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (re.test(String(email).toLowerCase())) {
        //Ок. ОТПРАВКА КОДА НА ПОЧТУ

        const requestParams = new RequestParams("POST");
        requestParams.url = "/api/users/token";
        requestParams.body = {
            email: email,
        }

        ServerRequest.send(requestParams)
            .then(data => {
                console.log(data);
                steap2();
            })
            .catch(err => {
                console.log(err);
                document.getElementById("error_email").textContent = "Помилка запиту.";
        });

        
    } else {
        if (email.length === 0) {
            document.getElementById("error_email").textContent = "Введіть пошту.";
        } else {
            document.getElementById("error_email").textContent = "Невірний адрес пошти.";
        }
        return;
    }
}

// ШАГ ВТОРОЙ. Проверка кода.
function check_code(){
    // Проверка ...
    document.getElementById("error_code").textContent = "⠀"; // Физический пробел. Не трогать.
    var code = document.getElementById("code").value;

    //Код верный.
    if(true){ 
        document.getElementById("steap2").style.display = "none";
        document.getElementById("steap3").style.display = "block";
    }else{ // Неверный
        document.getElementById("error_code").textContent = "Невірний код.";
    }
}

// ШАГ ТРЕТИЙ. Новый пароль.
function new_Pass(){
    document.getElementById("error_pass").textContent = "⠀";
    var pass = document.getElementById("pass").value;

    var rep = /^[a-zA-Z0-9]+$/;
    if (rep.test(String(pass).toLowerCase())) {
        if (pass.length === 0) {
            document.getElementById("error_pass").textContent = "Введіть пароль.";
            return;
        } else {
            if (pass.length < 8) {
                document.getElementById("error_pass").textContent = "Мінімум 8 символів.";
            } else {
                // ЗАПРОС СМЕНЫ ПАРОЛЯ. ВАЛИДАЦИЯ ПРОЙДЕНА.
                //...


                // Автоматический вход в аккаунт (выполнить запрос входа).
                //...
            }

        }
    } else {
        if (pass.length === 0) {
            document.getElementById("error_pass").textContent = "Введіть пароль.";
        } else {
            document.getElementById("error_pass").textContent = "Тільки латинськи літери";
        }
        return;
    }
}

function back_p1(){
    document.getElementById("steap2").style.display = "none";
    document.getElementById("steap1").style.display = "block";
}

function steap2(){
    document.getElementById("steap1").style.display = "none";
    document.getElementById("steap2").style.display = "block";
}