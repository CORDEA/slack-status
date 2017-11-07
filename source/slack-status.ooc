import slack/[Slack, Status]
import text/StringTokenizer
import structs/ArrayList
import io/FileReader

ENV_FILE := "env.props"

main: func (args: ArrayList<String>) {
    fr := FileReader new(ENV_FILE)
    token: String

    while (fr hasNext?()) {
        line := fr readLine()

        tokens := line split('=', 2)
        if (tokens[0] == "Token") {
            token = tokens[1]
        }
    }

    if (token) {
        slack := Slack new(token)
        if (args size < 3) {
            slack getUserProfile() toString() println()
        } else {
            slack setUserProfile(args[1], args[2]) toString() println()
        }
    }
}
