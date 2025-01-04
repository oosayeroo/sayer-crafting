// Each entry of Items contains:
// ItemCode - the code of the item
// Amount - amount you receive after crafting
// CraftTime - how many Seconds to craft
// LVLNeeded - level needed to craft item
// XPGain - how much xp to gain from successful craft
// SuccessChance - (%) chance of success
// Recipe - the recipe of the item (template below of how it looks)
// Recipe = {
//     [1] = {item = 'metalscrap',amount = 1,},
//     [2] = {item = 'plastic',amount = 1,},
// }

// Emote is for use outside of the UI and will only need to be sent with the crafting process
// LevelData contains level(number) and xp(number) 
window.addEventListener('message', (event) => {
    if (event.data.action === 'open-sayer-crafting') {
        const Items = event.data.Items;
        const Emote = event.data.Emote;
        const LevelData = event.data.LevelData;
        populateCraftingGrid(Items,Emote,LevelData); // will populate the crafting UI before showing it
        showCraftingUI(); //will now show the ui
    }
});