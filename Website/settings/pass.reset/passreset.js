//PRELOADER
window.onload = function () {
	document.body.classList.add('loaded_hiding');
	window.setTimeout(function () {
		document.body.classList.add('loaded');
		document.body.classList.remove('loaded_hiding');
	}, 500);
}

var token = 0;

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
                token = 15841984 * data.token / 4562123;
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
    if(token === 15841984 * code / 4562123){
        token = code;
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

                const requestParams = new RequestParams("POST");
                requestParams.url = "/api/users/change/forgotten";
                requestParams.body = {
                    Token: token,
                    Email: document.getElementById("email").value,
                    NewPassword: pass,
                }

                ServerRequest.send(requestParams)
                    .then(data => {
                        Cookies.set('id', data.id, { expires: 7, path: '/' });
                        Cookies.set('login', data.login, { expires: 7, path: '/' });
                        Cookies.set('email', data.email, { expires: 7, path: '/' });
                        if(data.avatarPath != null){
                            Cookies.set('avatarPath', data.avatarPath, { expires: 7, path: '/' });
                            document.getElementById("avatar").src = data.avatarPath;
                        }else{
                            Cookies.set('avatarPath', "/assets/images/user-48.png", { expires: 7, path: '/' });
                            document.getElementById("avatar").src = "/assets/images/user-48.png";
                        }
                        document.getElementById("steap3").style.display = "none";
                        document.getElementById("steap4").style.display = "block";
                    })
                    .catch(err => {
                        console.log(err);
                });
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