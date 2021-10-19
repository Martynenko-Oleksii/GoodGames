//
//   JAVASCRYPT Обработка форм
//   GOODGAMES @ Мірошніченко Станіслав / Олексенко Владіслав
//

function login_validation(){
    var email = document.getElementById("modal_login_email").value; var error_email = 0;
    var pass = document.getElementById("modal_login_pass").value; var error_pass = 0;

    //Валидация почты
    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (re.test(String(email).toLowerCase())) {
      //Ок
      error_email = 1;
    } else {
        if(email.length === 0){
            document.getElementById("modal_error_login_email").textContent = "Введіть пошту.";
        }else{
            document.getElementById("modal_error_login_email").textContent = "Невірний адрес пошти.";
        }
        error_email = 0;
    }

    //Валидация пароля
    var rep = /^[a-zA-Z0-9]+$/;
    if (rep.test(String(pass).toLowerCase())) {
        if(pass.length === 0){
            document.getElementById("modal_error_login_pass").textContent = "Введіть пароль.";
        }else{
            if(pass.length < 8){
                document.getElementById("modal_error_login_pass").textContent = "Мінімум 8 символів.";
            }else{
                error_pass = 1;
            }

        }
      } else {
          if(pass.length === 0){
              document.getElementById("modal_error_login_pass").textContent = "Введіть пароль.";
          }else{
              document.getElementById("modal_error_login_pass").textContent = "Тільки латинськи літери";
          }
          error_pass = 0;
    }

    if(error_email === 1 && error_pass === 1){
        console.log("Login done. Server response:");

        const requestUrl = "api/users/login"
        const requestBody = {
            email: email,
            pass: pass
        }

        ServerRequest.send("POST", requestUrl, requestBody)
          .then(data => console.log(data))
          .catch(err => console.log(err));
    }
}

function reg_validation(){
    var name = document.getElementById("modal_reg_name").value; var error_name = 0;
    var email = document.getElementById("modal_reg_email").value; var error_email = 0;
    var pass = document.getElementById("modal_ref_pass").value; var error_pass = 0;

    //Валидация имени
    var repsa = /^[a-zA-Z0-9]+$/;
    var rep = /^[a-zA-Z0-9]+$/;
    if (repsa.test(String(name).toLowerCase())) {
        if(name.length === 0){
            document.getElementById("modal_error_reg_name").textContent = "Введіть логін.";
        }else{
            if(name.length < 6){
                document.getElementById("modal_error_reg_name").textContent = "Мінімум 6, макс 20 символів.";
                if(20 < name.length){
                    document.getElementById("modal_error_reg_name").textContent = "Максимум 20 символів.";
                }
            }else{
                error_name = 1;
            }

        }
      } else {
          if(name.length === 0){
              document.getElementById("modal_error_reg_name").textContent = "Введіть логін.";
          }else{
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
        if(email.length === 0){
            document.getElementById("modal_error_reg_email").textContent = "Введіть пошту.";
        }else{
            document.getElementById("modal_error_reg_email").textContent = "Невірний адрес пошти.";
        }
        error_email = 0;
    }

    //Валидация пароля
    if (rep.test(String(pass).toLowerCase())) {
        if(pass.length === 0){
            document.getElementById("modal_error_ref_pass").textContent = "Введіть пароль.";
        }else{
            if(pass.length < 8){
                document.getElementById("modal_error_ref_pass").textContent = "Мінімум 8 символів.";
            }else{
                error_pass = 1;
            }

        }
      } else {
          if(pass.length === 0){
              document.getElementById("modal_error_ref_pass").textContent = "Введіть пароль.";
          }else{
              document.getElementById("modal_error_ref_pass").textContent = "Тільки латинськи літери";
          }
          error_pass = 0;
    }

    if(error_name === 1 && error_email === 1 && error_pass === 1){
        console.log("Reg done. Server response:");

        const requestUrl = "api/users/reg"
        const requestBody = {
            name: name,
            email: email,
            pass: pass
        }

        ServerRequest.send("POST", requestUrl, requestBody)
          .then(data => console.log(data))
          .catch(err => console.log(err));
    }
}