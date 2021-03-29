export function trackNavigation(url, from, to, meta) {
    if (!url) return;
    try {
        var fromParam = encodeURIComponent(from);
        var toParam = encodeURIComponent(to);
        var metaParams = meta
            ? "&" + Object.keys(meta).map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(meta[key])}`).join("&")
            : "";
        var xhr = new XMLHttpRequest();
        xhr.onerror = function () {};
        xhr.open("POST", `${url}?from=${fromParam}&to=${toParam}${metaParams}`, true);
        xhr.send(null);
    } catch (e) {
        // NOP
    }
}