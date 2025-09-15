// esbuild.config.js
const esbuild = require("esbuild");
const { sassPlugin } = require("esbuild-sass-plugin");

const watch = process.argv.includes("--watch");

const buildOptions = {
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  sourcemap: true,
  format: "iife",
  outdir: "app/assets/builds",
  publicPath: "/assets",
  plugins: [sassPlugin()],
  loader: {
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
    ".svg": "file",
    ".png": "file",
    ".jpg": "file",
    ".jpeg": "file",
    ".gif": "file",
  },
};

async function build() {
  if (watch) {
    const ctx = await esbuild.context(buildOptions);
    await ctx.watch();
    console.log("🚀 esbuild is watching for changes...");
  } else {
    await esbuild.build(buildOptions);
    console.log("✅ esbuild build complete");
  }
}

build().catch(() => process.exit(1));
