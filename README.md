# API
## User

**1. Register a new account**

**ENDPOINT**: *"/api/v1/users"*

**Method**: POST

Params               | Type          | Description
:-------------------:| :------------ | :-----------------------:
fullname             | String        | Name of user
email                | String        | Email of user
password             | String        | Password of user
address              | String        | Address of user
phone_number         | String        | Phone number of user

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
