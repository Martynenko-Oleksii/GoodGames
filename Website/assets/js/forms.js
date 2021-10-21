//
//   JAVASCRYPT Обработка форм
//   GOODGAMES @ Мірошніченко Станіслав / Олексенко Владіслав
//

function sayHi() {
    document.getElementById('modal_spinner_pop').remove();
    document.getElementById('modal_login_name_comp').textContent = "Привіт, " + Cookies.get('login');
    setTimeout("document.getElementById('close_modal').click();", 1400);
}

function login_validation() {
    var email = document.getElementById("modal_login_email").value;
    var error_email = 0;
    var pass = document.getElementById("modal_login_pass").value;
    var error_pass = 0;

    //Валидация почты
    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (re.test(String(email).toLowerCase())) {
        //Ок
        error_email = 1;
    } else {
        if (email.length === 0) {
            document.getElementById("modal_error_login_email").textContent = "Введіть пошту.";
        } else {
            document.getElementById("modal_error_login_email").textContent = "Невірний адрес пошти.";
        }
        error_email = 0;
    }

    //Валидация пароля
    var rep = /^[a-zA-Z0-9]+$/;
    if (rep.test(String(pass).toLowerCase())) {
        if (pass.length === 0) {
            document.getElementById("modal_error_login_pass").textContent = "Введіть пароль.";
        } else {
            if (pass.length < 8) {
                document.getElementById("modal_error_login_pass").textContent = "Мінімум 8 символів.";
            } else {
                error_pass = 1;
            }

        }
    } else {
        if (pass.length === 0) {
            document.getElementById("modal_error_login_pass").textContent = "Введіть пароль.";
        } else {
            document.getElementById("modal_error_login_pass").textContent = "Тільки латинськи літери";
        }
        error_pass = 0;
    }

    if (error_email && error_pass) {
        document.getElementById('modal_load_login').style.display = "grid";
        console.log("Login done. Server response:");

        const requestUrl = "api/users/login"
        const requestBody = {
            email: email,
            password: pass
        }

        ServerRequest.send("POST", requestUrl, requestBody)
            .then(data => {
                console.log(data);
                Cookies.set('id', data.id, { expires: 7, path: '/' });
                Cookies.set('login', data.login, { expires: 7, path: '/' });
                Cookies.set('email', data.email, { expires: 7, path: '/' });
                document.getElementById('login').textContent = "Профіль";
                document.getElementById('login_m').textContent = "Профіль";
                document.getElementById('login_icon').name = "person-outline";
                document.getElementById('login_m_icon').name = "person-outline";
                document.getElementById('profile').href = "/profile/";
                document.getElementById('showModal').href = "/profile/";
                document.getElementById('profile').onclick = "";
                document.getElementById('showModal').onclick = "";
                setTimeout("sayHi()", 1000);
            })
            .catch(err => {
                console.log(err);
                console.log('Ошибка.');
                document.getElementById("modal_error_login_pass").textContent = "Не вдалось увійти. Перевірте данні.";
                document.getElementById('modal_load_login').style.display = "none";
            });
    }
}

function reg_validation() {
    var name = document.getElementById("modal_reg_name").value;
    var error_name = 0;
    var email = document.getElementById("modal_reg_email").value;
    var error_email = 0;
    var pass = document.getElementById("modal_ref_pass").value;
    var error_pass = 0;

    //Валидация имени
    var repsa = /^[a-zA-Z0-9]+$/;
    var rep = /^[a-zA-Z0-9]+$/;
    if (repsa.test(String(name).toLowerCase())) {
        if (name.length === 0) {
            document.getElementById("modal_error_reg_name").textContent = "Введіть логін.";
        } else {
            if (name.length < 6) {
                document.getElementById("modal_error_reg_name").textContent = "Мінімум 6, макс 20 символів.";
                if (20 < name.length) {
                    document.getElementById("modal_error_reg_name").textContent = "Максимум 20 символів.";
                }
            } else {
                error_name = 1;
            }

        }
    } else {
        if (name.length === 0) {
            document.getElementById("modal_error_reg_name").textContent = "Введіть логін.";
        } else {
            document.getElementById("modal_error_reg_name").textContent = "Тільки латинськи літери";
        }
        error_name = 0;
    }


    //Валидация почты
    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (re.test(String(email).toLowerCase())) {
        //Ок
        error_email = 1;
    } else {
        if (email.length === 0) {
            document.getElementById("modal_error_reg_email").textContent = "Введіть пошту.";
        } else {
            document.getElementById("modal_error_reg_email").textContent = "Невірний адрес пошти.";
        }
        error_email = 0;
    }

    //Валидация пароля
    if (rep.test(String(pass).toLowerCase())) {
        if (pass.length === 0) {
            document.getElementById("modal_error_ref_pass").textContent = "Введіть пароль.";
        } else {
            if (pass.length < 8) {
                document.getElementById("modal_error_ref_pass").textContent = "Мінімум 8 символів.";
            } else {
                error_pass = 1;
            }

        }
    } else {
        if (pass.length === 0) {
            document.getElementById("modal_error_ref_pass").textContent = "Введіть пароль.";
        } else {
            document.getElementById("modal_error_ref_pass").textContent = "Тільки латинськи літери";
        }
        error_pass = 0;
    }

    var close = document.getElementById('close_modal');
    if (error_name && error_email && error_pass) {
        console.log("Reg done. Server response:");

        const requestUrl = "api/users/reg"
        const requestBody = {
            login: name,
            email: email,
            password: pass
        }

        ServerRequest.send("POST", requestUrl, requestBody)
            .then(data => {
                console.log(data);
                console.log('Отправлено');
                Cookies.set('id', data.id, { expires: 7, path: '/' });
                Cookies.set('login', data.login, { expires: 7, path: '/' });
                Cookies.set('email', data.email, { expires: 7, path: '/' });
                close.click();
                document.location.href = "/profile/";
            })
            .catch(err => {
                console.log(err);
                document.getElementById("modal_error_login_pass").textContent = "Помилка, змініть данні.";
                console.log('Ошибка.');
            });
    }
}