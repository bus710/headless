<script>
    export let number = 1;
    export let live;

    function increase() {
        live.pushEvent("set_number", { number: number + 1 }, () => {});
    }
</script>

<div class="flex gap-x-16">
    <p>The number is {number}</p>
    <button
        on:click={increase}
        class="btn-info w-32 bg-violet-800 text-cyan-50 rounded-xl">+</button
    >
</div>
