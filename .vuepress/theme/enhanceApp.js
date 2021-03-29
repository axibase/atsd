import { trackNavigation } from "./tracknav";

export default function ({siteData, router}) {
    var remarkConfig = siteData.themeConfig.remark42Config;
    var trackNavUrl = siteData.themeConfig.trackNavURL;

    if (remarkConfig && typeof window !== "undefined") {
        window.remark_config = { ...remarkConfig };

        (function (c) {
            for (var i = 0; i < c.length; ++i) {
                var d = document, s = d.createElement('script');
                s.src = remarkConfig.host + '/web/' + c[i] + '.js';
                s.defer = true;
                s.id = "remark42-load-script";
                (d.head || d.body).appendChild(s);
            }
        })(remarkConfig.components || ["embed"]);
    }

    if (siteData.themeConfig.trackNavURL) {
        router.afterEach((to, from) => {
            var isInitial = from == null || (from.name === null && from.fullPath === "/");
            if (isInitial) return;
            const fromUrl = siteData.base + from.fullPath.slice(1);
            const toUrl = siteData.base + to.fullPath.slice(1);
            trackNavigation(trackNavUrl, fromUrl, toUrl);
        });
    }
}