PostSchema = new Schema(
  title:
    type: String
    default: ""
    trim: true

  body:
    type: String
    default: ""
    trim: true

  created_at:
    type: Date
    default: Date.now
)
mongoose.model "Post", PostSchema