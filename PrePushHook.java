import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class PrePushHook {
    public static void main(String[] args) throws IOException {
        final String protectedBranch = "develop";

        // 標準入力を読み取る（Gitから提供される入力）
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("hoge");
        // System.out.println(reader.readLine());
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
            System.out.println("foo");
            String[] refs = line.split("\\s+"); // スペースやタブで分割
            if (refs.length >= 3) {
                String remoteRef = refs[2]; // リモートブランチ
                if (remoteRef.startsWith("refs/heads/")) {
                    String remoteBranch = remoteRef.replace("refs/heads/", "");
                    if (remoteBranch.equals(protectedBranch)) {
                        System.err.println("Error: pushing to '" + protectedBranch + "' branch is not allowed.");
                        System.exit(1); // エラーコードを返して終了
                    }
                }
            }
        }
        System.exit(0); // 正常終了
    }
}
