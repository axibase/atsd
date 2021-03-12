export default function ({siteData, router}) {
    var remarkConfig = siteData.themeConfig.remark42Config;

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
        var trackNav = siteData.themeConfig.trackNavURL;
        router.afterEach((to, from) => {
            try {
                var isInitial = from.name === null && from.fullPath === "/";
                if (isInitial) return;

                var fromParam = encodeURIComponent(siteData.base + from.fullPath.slice(1));
                var toParam = encodeURIComponent(siteData.base + to.fullPath.slice(1));
                var xhr = new XMLHttpRequest();
                xhr.onerror = function () {};
                xhr.open("POST", `${trackNav}?from=${fromParam}&to=${toParam}`, true);
                xhr.send(null);
            } catch (e) {
                // NOP
            }
        });
    }
}