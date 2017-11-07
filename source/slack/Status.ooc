Status: cover {
    text, emoji: String

    init: func@ (=text, =emoji)

    toString: func -> String {
        return "#{emoji} #{text}"
    }
}
