class FindReadingsAround {
    constructor(container) {
        container = $(container);
        this.dateInput = container.find(".finder-input-date");
        this.submitButton = container.find(".finder-submit");
        this.meterId = container.data('meterId');

        this.resultContainer = container.find(".finder-result-container");
        this.beforeContainer = this.resultContainer.find(".finder-result-before");
        this.afterContainer = this.resultContainer.find(".finder-result-after");
    }

    initialize() {
        $(this.submitButton).on("click", () => this.updateValues());
    }

    updateValues() {
        $.ajax({ url: "/meters/" + this.meterId + "/readings/around", data: { time: this.dateInput.val() } })
            .done((data) => {
                this.resultContainer.removeClass("hidden");

                if(data.before) {
                    this.beforeContainer.find(".finder-result-time").text(data.before.time);
                    this.beforeContainer.find(".finder-result-value").text(data.before.value);
                } else {
                    this.beforeContainer.find(".finder-result-time").text("-");
                    this.beforeContainer.find(".finder-result-value").text("-");
                }

                if(data.after) {
                    this.afterContainer.find(".finder-result-time").text(data.after.time);
                    this.afterContainer.find(".finder-result-value").text(data.after.value);
                } else {
                    this.afterContainer.find(".finder-result-time").text("-");
                    this.afterContainer.find(".finder-result-value").text("-");
                }
            });
    }
}

$(() => {
    $(".find-readings-around").each((i, e) => new FindReadingsAround(e).initialize())
});
