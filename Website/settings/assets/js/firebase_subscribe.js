// firebase_subscribe.js
firebase.initializeApp({
    messagingSenderId: '222600043964'
});


// браузер поддерживает уведомления
// вообще, эту проверку должна делать библиотека Firebase, но она этого не делает
if ('Notification' in window) {
    var messaging = firebase.messaging();

    if (Notification.permission === 'denied') {
        document.getElementById('switch').checked = false;
    }
    // пользователь уже разрешил получение уведомлений
    // подписываем на уведомления если ещё не подписали
    if (Notification.permission === 'granted') {
        subscribe();
    }

    // по клику, запрашиваем у пользователя разрешение на уведомления
    // и подписываем его
    $('#subscribe').on('click', function () {
        if(document.getElementById('switch').checked == false){
            subscribe();
        }
    });
}

function subscribe() {
    // запрашиваем разрешение на получение уведомлений
    messaging.requestPermission()
        .then(function () {
            // получаем ID устройства
            messaging.getToken()
                .then(function (currentToken) {
                    console.log(currentToken);

                    if (currentToken) {
                        sendTokenToServer(currentToken);
                    } else {
                        console.warn('Не удалось получить токен.');
                        setTokenSentToServer(false);
                    }
                })
                .catch(function (err) {
                    console.warn('При получении токена произошла ошибка.', err);
                    setTokenSentToServer(false);
                });
    })
    .catch(function (err) {
        console.warn('Не удалось получить разрешение на показ уведомлений.', err);
    });
}

// отправка ID на сервер
function sendTokenToServer(currentToken) {
    if (!isTokenSentToServer(currentToken)) {
        console.log('Отправка токена на сервер...');

        const requestParams = new RequestParams("POST");
        requestParams.url = "/api/users/newstoken";
        requestParams.body = {
            UserId: Cookies.get('id'),
            Token: currentToken,
        }

        ServerRequest.send(requestParams)
            .then(data => {
                console.log(data);
                setTokenSentToServer(currentToken);
                document.getElementById('switch').checked = true;
                document.getElementById('switch').setAttribute('disabled', true);
            })
            .catch(err => {
                console.log(err);
            });
    } else {
        console.log('Токен уже отправлен на сервер.');
        document.getElementById('switch').checked = true;
        document.getElementById('switch').setAttribute('disabled', true);
    }
}

// используем localStorage для отметки того,
// что пользователь уже подписался на уведомления
function isTokenSentToServer(currentToken) {
    return window.localStorage.getItem('sentFirebaseMessagingToken') == currentToken;
}

function setTokenSentToServer(currentToken) {
    window.localStorage.setItem(
        'sentFirebaseMessagingToken',
        currentToken ? currentToken : ''
    );
}

if(document.getElementById('switch').checked === true){
    document.getElementById('switch').setAttribute('disabled', true);
}