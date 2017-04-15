# API

## Session

**1. Login user**

**ENDPOINT**: *"/api/v1/login"*

**Method**: POST

**Parameters**

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

**Parameters**

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

**2. Show current user information**

**ENDPOINT**: *"/api/v1/users/current_user"*

**Method**: GET

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of user
Tokenkey             | String        | Token key

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
401                  | Authenticate fail
404                  | User not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success": true,
  "message": "Get user info successfully",
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

**3. Update current user information**

**ENDPOINT**: *"/api/v1/users/current_user"*

**Method**: PATCH

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of user
Tokenkey             | String        | Token key

**Parameters**

Params               | Type          | Description              | Requires?
:-------------------:| :------------ | :-----------------------:|:---------------:
fullname             | String        | Name of user             | No
email                | String        | Email of user            | No
address              | String        | Address of user          | No
phone_number         | String        | Phone number of user     | No

***Note:** At least one parameter must be selected*

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | customer.errors.messages
401                  | Authenticate fail
404                  | User not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success": true,
  "message": "Update user info successfully",
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

**4. Change password of current user**

**ENDPOINT**: *"/api/v1/users/current_user/change_password"*

**Method**: PATCH

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of user
Tokenkey             | String        | Token key

**Parameters**

Params               | Type          | Description              | Requires?
:-------------------:| :------------ | :-----------------------:|:---------------:
old_password         | String        | Old password of user     | Yes
new_password         | String        | New password of user     | Yes

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | user.errors.messages
401                  | Authenticate fail
404                  | User not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success": true,
  "message": "Change password successfully",
  "user": {
    "id": 1,
    "email": "new_user@gmail.com",
    "password_digest": "$2a$10$UZWymaY82ik8toaBakZLtODbB1lWEHR.c7pIca3X5H5uMDBd5PHYG",
    "status": "Active",
    "created_at": "2017-03-28T18:17:43.222Z",
    "updated_at": "2017-03-28T18:17:43.229Z",
    "customer_id": 1
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
# API ADMIN

## AdminSession

**1. Login admin**

**ENDPOINT**: *"/api/v1/admins/login"*

**Method**: POST

**Parameters**

Params               | Type          | Description              | Requires?
:-------------------:| :------------:| :-----------------------:|:---------------:
email                | String        | Email of admin           | Yes
password             | String        | Password of admin        | Yes

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
  "admin": {
    "id":1,
    "email":"admin@test.com",
    "password_digest":"$2a$10$rnrME50rFvm2apJiE/xeQeK6oj9UlaBYpg8QZAK.VncTbnetxVIta",
    "status":"active",
    "created_at":"2017-03-29T07:54:41.963Z",
    "updated_at":"2017-03-29T07:54:41.963Z",
  },
  "token_key":"6e795d97adf171f5c4694f7ed5569d19"
}
```

**2. Logout admin**

**ENDPOINT**: *"/api/v1/admins/logout"*

**Method**: POST

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
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
## SupplierAPI

**1. Index suppliers**

**ENDPOINT**: *"/api/v1/admins/suppliers"*

**Method**: GET

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
Tokenkey             | String        | Token key

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
200                  | Success
401                  | Authenticate fail
404                  | Admin not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Index suppliers successfully",
  "suppliers":
  [
    {
      "id":1,
      "name":"LongBB",
      "address":"HN",
      "phone_number":"1234567890",
      "description":"Chuyen buon ban cho meo",
      "status":"active",
      "created_at":"2017-04-15T03:01:34.932Z",
      "updated_at":"2017-04-15T03:01:34.932Z"
    },
    {
      "id":2,
      "name":"LinhNN",
      "address":"HN",
      "phone_number":"1234567890",
      "description":"Chuyen rau cu qua hang ngay",
      "status":"active",
      "created_at":"2017-04-15T03:19:46.886Z",
      "updated_at":"2017-04-15T03:19:46.886Z"
    }
  ]
}

```

**2. Show supplier information**

**ENDPOINT**: *"/api/v1/admins/suppliers/:id"*

**Method**: GET

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
Tokenkey             | String        | Token key

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
401                  | Authenticate fail
404                  | Suppier not found/ Admin not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Show supplier successfully",
  "supplier":
  {
    "id":1,
    "name":"LongBB",
    "address":"HN",
    "phone_number":"1234567890",
    "description":"Chuyen buon ban cho meo",
    "status":"active",
    "created_at":"2017-04-15T03:01:34.932Z",
    "updated_at":"2017-04-15T03:01:34.932Z"
  }
}

```

**3. Create new supplier**

**ENDPOINT**: *"/api/v1/admins/suppliers"*

**Method**: POST

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
Tokenkey             | String        | Token key

**Parameters**

Params               | Type          | Description              | Requires?
:-------------------:| :------------ | :-----------------------:|:---------------:
name                 | String        | Name of supplier         | Yes
description          | String        | Email of supplier        | Yes
address              | String        | Address of supplier      | Yes
phone_number         | String        | Phone number of supplier | Yes

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | supplier.errors.messages
401                  | Authenticate fail
404                  | Admin not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Create supplier successfully",
  "supplier":
  {
    "id":4,
    "name":"NganPTK",
    "address":"Thai Binh",
    "phone_number":"1234567890",
    "description":"Chuyen san xuat tien gia",
    "status":"active",
    "created_at":"2017-04-15T03:38:11.832Z",
    "updated_at":"2017-04-15T03:38:11.832Z"
  }
}
```

**4. Update supplier information**

**ENDPOINT**: *"/api/v1/admins/suppliers/:id"*

**Method**: PATCH

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
Tokenkey             | String        | Token key

**Parameters**

Params               | Type          | Description              | Requires?
:-------------------:| :------------ | :-----------------------:|:---------------:
name                 | String        | Name of supplier         | No
description          | String        | Email of supplier        | No
address              | String        | Address of supplier      | No
phone_number         | String        | Phone number of supplier | No

***Note:** At least one parameter must be selected*

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | supplier.errors.messages
401                  | Authenticate fail
404                  | Admin not found/ Supplier does not exist
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Update supplier info successfully",
  "supplier":
  {
    "status":"active",
    "id":3,
    "description":"Chuyen san xuat tien gia sang buon ban giay dep",
    "name":"NganPTK",
    "address":"Thai Binh",
    "phone_number":"1234567890",
    "created_at":"2017-04-15T03:32:51.433Z",
    "updated_at":"2017-04-15T03:45:34.857Z"
  }
}
```

**4. Delete supplier information**

**ENDPOINT**: *"/api/v1/admins/suppliers/:id"*

**Method**: DELETE

**Headers**

Headers              | Type          | Description
:-------------------:| :------------:| :-----------------------:
Authorization        | String        | Email of admin
Tokenkey             | String        | Token key

**Response**:

Code                 | Description
:-------------------:| :---------------------------:
201                  | Success
400                  | supplier.errors.messages
401                  | Authenticate fail
404                  | Admin not found/ Supplier not found
500                  | Something error (system error)

**Structure of JSON**

```json
{
  "success":true,
  "message":"Delete supplier successfully"
}
```
