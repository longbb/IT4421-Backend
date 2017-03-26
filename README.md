# API
## User

**1. Register a new account**

**ENDPOINT**: *"/api/v1/users"*

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
  "success": true,
  "message": "User has been created",
  "user": {
    "id": 1,
    "fullname": "new member",
    "email": "new_member@member.com",
    "password_digest": "$2a$10$D9rYPXPLqDDvyzJ.bHFyZ.jHeTXCzjf7.Jwf.yEtazVFCj3.M/02i",
    "address": "new address",
    "phone_number": "0123456789",
    "status": "Active",
    "created_at": "2017-03-26T16:06:51.267Z",
    "updated_at": "2017-03-26T16:06:51.267Z"
  }
}
```
