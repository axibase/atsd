/**
 * Plugin checks relative image urls start with './' or '../', which is required
 * by Vuepress image loader
 */

const testExternal = /^(?:https?\:)?\/\//;
const testValidRelative = /^(?:\.\.?\/)/;

module.exports = {
    names: ["relative-image-urls"],
    description: "Relative URLs to images must start with ./ or ../",
    tags: ["links"],
    "function": (params, onError) => {
        params.tokens.filter(t => t.type === "inline").forEach(token => {
            let images = token.children.filter(t => t.type === "image")
            for (let img of images) {
                let src = img.attrGet("src")
                if (src) {
                    let isExternal = testExternal.test(src);
                    let isValidRelative = testValidRelative.test(src);
                    if (!isExternal && !isValidRelative) {
                        let index = img.line.indexOf(src);
                        let range =  [index+1, src.length];
                        onError({
                            lineNumber: img.lineNumber,
                            details: `In the image for ${img.content}`,
                            context: `![${src}](${img.content})`,
                            range,
                        })
                    }
                }
            }
        });
    }
};