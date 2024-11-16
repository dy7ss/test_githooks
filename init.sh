#!/bin/sh


JAVA_INTERCEPT_SCRIPT=$(cat << 'EOF'
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

public class PrePushHook {
    public static void main(String[] args) throws IOException {
        List<String> PROTECTED_BRANCHES = List.of(
            "develop", 
            "main");

        // 標準入力を読み取る（Gitから提供される入力）
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;
        while ((line = reader.readLine()) != null) {
            String[] refs = line.split("\\s+");
            if (refs.length >= 3) {
                String remoteRef = refs[2];
                if (remoteRef.startsWith("refs/heads/")) {
                    String remoteBranch = remoteRef.replace("refs/heads/", "");
                    if (PROTECTED_BRANCHES.contains(remoteBranch)) {
                        System.err.println("Error: pushing to '" + remoteBranch + "' branch is not allowed.");
                        System.exit(1);
                    }
                }
            }
        }
        System.exit(0);
    }
}
EOF
)


create_pre_push() {
    echo "#!/bin/sh
java ./PrePushHook.java" >.git/hooks/pre-push && chmod +x .git/hooks/pre-push
}

create_pre_push_java() {
    FILE_PATH=".git/hooks/PrePushHook.java"
echo "$JAVA_INTERCEPT_SCRIPT" > $FILE_PATH && chmod +x $FILE_PATH
}

main() {
    create_pre_push
    create_pre_push_java
}

main
