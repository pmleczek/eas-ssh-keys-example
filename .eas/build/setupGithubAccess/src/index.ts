import spawnAsync, { SpawnOptions, SpawnResult } from "@expo/spawn-async";
import { BuildStepContext } from "@expo/steps";
import { appendFile, mkdir, writeFile } from "node:fs/promises";
import { homedir } from "node:os";

// Utility wrapper around spawnAsync from @expo/spawn-async
async function runCommand(
 cmd: string,
 args?: string[],
 options?: SpawnOptions
): Promise<SpawnResult> {
 const result = await spawnAsync(cmd, args, options);

 if (result.status !== 0) {
   throw new Error(result.stderr);
 }

 return result;
}

async function setupGithubAccess(ctx: BuildStepContext): Promise<void> {
 // Skip set up if the build is ran locally
 if (
   "EAS_BUILD_RUNNER" in ctx.global.env &&
   ctx.global.env["EAS_BUILD_RUNNER"] === "local-build-plugin"
 ) {
   ctx.logger.info("The build is being ran locally");
   ctx.logger.info("Skipping the GitHub SSH key setup");
   return;
 }

 // Store the value of the user's home directory
 const HOME_DIRECTORY = homedir();

 // Create the $HOME/.ssh directory
 await mkdir(HOME_DIRECTORY + "/.ssh", { recursive: true });

 // Restore private key from env variable and generate public key
 if (!("GITHUB_SSH_KEY" in ctx.global.env)) {
   ctx.logger.error("Variable GITHUB_SSH_KEY not found in the environment");
   throw new Error("Could not find GITHUB_SSH_KEY in the environment");
 }

 const sshKey = ctx.global.env["GITHUB_SSH_KEY"] ?? "";
 const sshKeyBuffer = Buffer.from(sshKey, "base64");

 process.umask(0o0177);
 await writeFile(
   HOME_DIRECTORY + "/.ssh/id_rsa",
   sshKeyBuffer.toString("utf8")
 );

 const { stdout } = await runCommand("ssh-keygen", [
   "-y",
   "-f",
   HOME_DIRECTORY + "/.ssh/id_rsa",
 ]);

 process.umask(0o0022);
 await writeFile(HOME_DIRECTORY + "/.ssh/id_rsa.pub", stdout);

 // Add GitHub to the known hosts
 const { stdout: stdoutHosts } = await runCommand("ssh-keyscan", [
   "github.com",
 ]);
 await appendFile(HOME_DIRECTORY + "/.ssh/known_hosts", stdoutHosts);

 // Swt up Git user name and email
 await runCommand("git", [
   "config",
   "--global",
   "user.name",
   "<Your first name>",
   "<Your last name>",
 ]);

 await runCommand("git", [
   "config",
   "--global",
   "user.email",
   "<Your email>",
 ]);
}

export default setupGithubAccess;
