<script>
export default {
    data() {
        return { remark42Instance: null };
    },
    props: ["config"],
    render(h) {
        return h("div", {class: "remark-comments-wrapper" }, [
            h("div", { ref: "comments", attrs: { id: "remark42" } })
        ]);
    },
    mounted() {
        this.initialize();
    },

    watch: {
        '$route' (to, from) {
            if (to.path !== from.from) {
                this.load();
            }
        }
    },
    methods: {
        initialize() {
            if (window.REMARK42) {
                this.load();
                return;
            } else {
                let loadScript = document.getElementById("remark42-load-script");
                if (loadScript) {
                    loadScript.onload = () => { this.load(); };
                } else {
                    setTimeout(() => this.initialize(), 1000);
                }
            }
        },

        load() {
            if (window.REMARK42) {
                this.destroy();
                this.remark42Instance = window.REMARK42.createInstance({
                    node: this.$refs.comments,
                    ...this.$props.config
                });
            }
        },

        destroy() {
            if (this.remark42Instance) {
                this.remark42Instance.destroy();
            }
        }
    }
}
</script>