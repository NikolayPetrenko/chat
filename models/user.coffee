encodePassword = (pass) ->
  return ""  if typeof pass is "string" and pass.length < 6
  SHA2.b64_hmac pass, salt
SHA2 = new (require("jshashes").SHA512)()
salt = "zAq12wSx"

mongooseValidator = require("mongoose-validator")
validator = mongooseValidator.validator
validator.verbose = true

UserSchema = new Schema(
  name:
    type: String
    required: true
    unique: true
    trim: true

  email:
    type: String
    required: true
    unique: true
    trim: true
    lowercase: true

  password:
    type: String
    set: encodePassword
    validate: [validator.notEmpty("Password should be not empty"), validator.len(6, 50, "Password should be at least 6 characters")]
)
mongoose.model "User", UserSchema