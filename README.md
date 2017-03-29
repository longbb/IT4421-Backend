# API

## Session

**1. Login user**

**ENDPOINT**: *"/api/v1/login"*

**Method**: POST

Params               | Type          | Description              | Requires?
:-------------------:| :------------:| :-----------------------:|:---------------:
email                | String        | Email of user            | Yes
password             | String        | Password of user         | Yes

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Login successfully
401                  | Invalid email or password
403                  | Permission denied
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Login successfully",
  "user": {
    "id":1,
    "email":"user@test.com",
    "password_digest":"$2a$10$rnrME50rFvm2apJiE/xeQeK6oj9UlaBYpg8QZAK.VncTbnetxVIta",
    "status":"Active",
    "created_at":"2017-03-29T07:54:41.963Z","
    updated_at":"2017-03-29T07:54:41.963Z",
    "customer_id":1
  },
  "token_key":"6e795d97adf171f5c4694f7ed5569d19"
}
```

**2. Logout user**

**ENDPOINT**: *"/api/v1/logout"*

**Method**: POST

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of user
Tokenkey             | String        | Token key

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Login successfully
401                  | Invalid email or password
403                  | Permission denied
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Logout successfully"
}
```

## User

**1. Register a new account**

**ENDPOINT**: *"/api/v1/users"*

**Method**: POST

Params               | Type          | Description              | Requires?
:-------------------:| :------------ | :-----------------------:|:---------------:
fullname             | String        | Name of user             | Yes
email                | String        | Email of user            | Yes
password             | String        | Password of user         | Yes
address              | String        | Address of user          | Yes
phone_number         | String        | Phone number of user     | Yes

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | user.errors.messages
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"User has been created",
  "user": {
    "id": 1,
    "email": "new_user@gmail.com",
    "password_digest": "$2a$10$UZWymaY82ik8toaBakZLtODbB1lWEHR.c7pIca3X5H5uMDBd5PHYG",
    "status": "Active",
    "created_at": "2017-03-28T18:17:43.222Z",
    "updated_at": "2017-03-28T18:17:43.229Z",
    "customer_id": 1
  },
  "customer": {
    "id": 1,
    "fullname": "new_user",
    "email": "new_user@gmail.com",
    "address": "HN",
    "phone_number": "1234567890",
    "status": "Active",
    "created_at": "2017-03-28T18:17:43.137Z",
    "updated_at": "2017-03-28T18:17:43.137Z"
  }
}
```

## Feedback

**1. Create feedback**

**ENDPOINT**: *"/api/v1/feedback"*

**Method**: POST

Params               | Type          | Description              | Requires?
:-------------------:| :------------:| :-----------------------:|:---------------:
email                | String        | Email of user            | Yes
feedback             | String        | Content of feedback      | Yes

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Create feedback successfully
400                  | feedback.errors.messages
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success": true,
  "message": "Create feedback successfully",
  "feedback": {
    "id": 2,
    "email": "linh@test.com",
    "feedback": "sdfghjklkmn",
    "status": "active",
    "created_at": "2017-03-29T17:22:11.146Z",
    "updated_at": "2017-03-29T17:22:11.146Z"
  }
}
```
