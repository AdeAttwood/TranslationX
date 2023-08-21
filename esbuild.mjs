import * as esbuild from "esbuild";
import { sassPlugin } from "esbuild-sass-plugin";

const config = {
  entryPoints: ["app/javascript/application.js"],
  plugins: [sassPlugin()],
  bundle: true,
  sourcemap: true,
  outdir: "app/assets/builds",
  publicPath: "/assets",
  loader: {
    ".woff": "file",
    ".woff2": "file",
    ".eot": "file",
    ".svg": "file",
    ".ttf": "file",
  },
};

const [_, __, command] = process.argv;
async function main() {
  await esbuild.build(config);

  if (command === "watch") {
    const context = await esbuild.context(config);
    await context.watch();
    console.log("Watching for changes...");
  }
}

main();
