export default function ({siteData}) {
    var remarkConfig = siteData.themeConfig.remark42Config;

    if (remarkConfig && typeof window !== "undefined") {
        window.remark_config = remarkConfig;

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
}