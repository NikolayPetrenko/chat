PostSchema = new Schema(
  user:
    type: String
    default: "Anonym"
    trim: true

  body:
    type: String
    trim: true

  created_at:
    type: Date
    default: Date.now
)
mongoose.model "Post", PostSchema