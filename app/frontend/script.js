async function loadEvent(){

    const getURL = (date, apikey = "api_key=DEMO_KEY") => {
        return `https://api.nasa.gov/planetary/apod?date=${date}&${apikey}`
    };

    const urlToday = getURL("2024-06-18");
    const urlYesterday = getURL("2023-06-17");

    async function fetchData(url) {
        try {
            const response = await fetch(url);
            const data = await response.json();
            return data;
        } catch (error) {
            console.error(error);
        }
    }

    const root = document.querySelector("#root");

    const createContent = (fetchedObject) => {
        return `
            <div id="imageContent">
                <img src=${fetchedObject.url} />
                <h2 class="title">${fetchedObject.title}</h2>
                <p class="explanation">${fetchedObject.explanation}</p>
            </div>
        `;
    }

    const today = new Date();
    const todayFormatted = today.toISOString().slice(0, 10);
    console.log(todayFormatted);
    const firstContent = await fetchData(getURL(todayFormatted));

    const addDatePicker = () => {
        const today = new Date();
        return `
            <div id="navBar">
                <input id="datePicker" type="date" value="${today.getFullYear()}-${today.getMonth()+1}-${today.getDate()}" />
            </div>
        `
    }
    root.insertAdjacentHTML("beforeend", addDatePicker());

    const datePickerElement = document.querySelector("#datePicker");
    datePickerElement.addEventListener("change", async (event) => {

        document.getElementById("imageContent") ? document.getElementById("imageContent").remove() : null;

        const newContent = await fetchData(getURL(`${event.target.value}`));
        root.insertAdjacentHTML("beforeend", createContent(newContent));
    })

    const navBar = document.getElementById("navBar");

    datePickerElement.insertAdjacentHTML("beforebegin", `<button id="prev"><</button>`);
    navBar.insertAdjacentHTML("beforeend", `<button id="next">></button>`);

    root.insertAdjacentHTML("beforeend", createContent(firstContent));

    window.addEventListener("click", async (event) => {
        switch (event.target.id){
            case "prev":

                nextButton.style.visibility = "visible";

                const displayedDatePrev = new Date (datePickerElement.value);
                
                displayedDatePrev.setDate(displayedDatePrev.getDate() - 1);
                const prevDay = new Date (displayedDatePrev);
                const prevDayFormatted = prevDay.toISOString().slice(0, 10);
                
                document.getElementById("imageContent") ? document.getElementById("imageContent").remove() : null;

                const newContentPrev = await fetchData(getURL(prevDayFormatted));
                root.insertAdjacentHTML("beforeend", createContent(newContentPrev));

                datePickerElement.value = prevDayFormatted;

                break;

            case "next":
                
                const displayedDateNext = new Date (datePickerElement.value);
                const todayCheck = new Date ();

                displayedDateNext.setDate(displayedDateNext.getDate() + 1);
                const nextDay = new Date (displayedDateNext);
                const nextDayFormatted = nextDay.toISOString().slice(0, 10);

                document.getElementById("imageContent") ? document.getElementById("imageContent").remove() : null;

                const newContentNext = await fetchData(getURL(nextDayFormatted));
                root.insertAdjacentHTML("beforeend", createContent(newContentNext));

                datePickerElement.value = nextDayFormatted;

                console.log(displayedDateNext.toISOString())
                console.log(todayCheck.toISOString())

                if (displayedDateNext.toISOString().slice(0, 10) === todayCheck.toISOString().slice(0, 10)){
                    nextButton.style.visibility = "hidden";
                }
                break;
        }
    })
    
    const nextButton = document.getElementById("next");
    nextButton.style.visibility = "hidden";
}

window.addEventListener("load", loadEvent);