local loremIpsum = [[
Sed ducimus nisi consectetur excepturi. Culpa dolores voluptatem quo aut debitis cum distinctio voluptas. Non deserunt dolore id aut magni dolore sit. In error doloribus quasi harum.

Doloremque et dolor sit molestiae quia id rerum. Quia a laudantium omnis voluptatem aut magni. Expedita distinctio ut molestiae assumenda.

Vero sint asperiores sint ad et ducimus omnis blanditiis. Porro corporis veritatis quo consequatur voluptatum itaque cum. Consequatur nihil optio soluta beatae corporis distinctio sed dolores.

Hic assumenda aliquid sunt delectus. Ratione consequatur impedit fuga dolorum a quidem et. Ea illum eius qui placeat exercitationem.

Aspernatur in animi sint perspiciatis aliquam iste vero quas. Cumque beatae vel aut dolorum eos. Alias eligendi iure et et quia non autem possimus. Consectetur vel dicta ut. Officiis ex blanditiis non molestias. Non sed velit rerum aliquid doloribus.
]]

local PrimeUI = require "init"
local term = require "system.terminal".openterm()

PrimeUI.clear(term)
PrimeUI.label(term, 3, 2, "Sample Text")
PrimeUI.horizontalLine(term, 3, 3, #("Sample Text") + 2)
PrimeUI.borderBox(term, 4, 6, 40, 10)
local scroller = PrimeUI.scrollBox(term, 4, 6, 40, 10, 9000, true, true)
PrimeUI.drawText(scroller, loremIpsum, true)
PrimeUI.button(term, 3, 18, "Next", "done")
PrimeUI.keyAction(keys.enter, "done")
PrimeUI.run()

PrimeUI.clear(term)
PrimeUI.label(term, 3, 2, "Sample Text")
PrimeUI.horizontalLine(term, 3, 3, #("Sample Text") + 2)
PrimeUI.borderBox(term, 4, 6, 40, 10)
local entries = {
    ["Item 1"] = false,
    ["Item 2"] = false,
    ["Item 3"] = "R",
    ["Item 4"] = true,
    ["Item 5"] = false
}
PrimeUI.checkSelectionBox(term, 4, 6, 40, 10, entries)
PrimeUI.button(term, 3, 18, "Next", "done")
PrimeUI.keyAction(keys.enter, "done")
PrimeUI.run()

PrimeUI.clear(term)
PrimeUI.label(term, 3, 2, "Sample Text")
PrimeUI.horizontalLine(term, 3, 3, #("Sample Text") + 2)
PrimeUI.label(term, 3, 5, "Enter some text.")
PrimeUI.borderBox(term, 4, 7, 40, 1)
PrimeUI.inputBox(term, 4, 7, 40, "result")
local _, _, text = PrimeUI.run()

PrimeUI.clear(term)
PrimeUI.label(term, 3, 2, "Sample Text")
PrimeUI.horizontalLine(term, 3, 3, #("Sample Text") + 2)
local entries2 = {
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
    "Option 5"
}
local entries2_descriptions = {
    "Sed ducimus nisi consectetur excepturi. Culpa dolores voluptatem quo aut debitis cum distinctio voluptas. Non deserunt dolore id aut magni dolore sit. In error doloribus quasi harum.",
    "Doloremque et dolor sit molestiae quia id rerum. Quia a laudantium omnis voluptatem aut magni. Expedita distinctio ut molestiae assumenda.",
    "Vero sint asperiores sint ad et ducimus omnis blanditiis. Porro corporis veritatis quo consequatur voluptatum itaque cum. Consequatur nihil optio soluta beatae corporis distinctio sed dolores.",
    "Hic assumenda aliquid sunt delectus. Ratione consequatur impedit fuga dolorum a quidem et. Ea illum eius qui placeat exercitationem.",
    "Aspernatur in animi sint perspiciatis aliquam iste vero quas. Cumque beatae vel aut dolorum eos. Alias eligendi iure et et quia non autem possimus. Consectetur vel dicta ut. Officiis ex blanditiis non molestias. Non sed velit rerum aliquid doloribus."
}
local redraw = PrimeUI.textBox(term, 3, 15, 40, 3, entries2_descriptions[1])
PrimeUI.borderBox(term, 4, 6, 40, 8)
PrimeUI.selectionBox(term, 4, 6, 40, 8, entries2, "done", function(option) redraw(entries2_descriptions[option]) end)
local _, _, selection = PrimeUI.run()

PrimeUI.clear(term)
PrimeUI.label(term, 3, 2, "Sample Text")
PrimeUI.horizontalLine(term, 3, 3, #("Sample Text") + 2)
PrimeUI.centerLabel(term, 3, 5, 42, "Executing " .. selection .. "...")
PrimeUI.borderBox(term, 4, 7, 40, 1)
local progress = PrimeUI.progressBar(term, 4, 7, 40, nil, nil, true)
local function updateProgress(i)
    progress(i / 20)
    if i < 20 then PrimeUI.timeout(0.1, function() updateProgress(i + 1) end)
    else PrimeUI.resolve("updateProgress", "done") end
end
updateProgress(0)
PrimeUI.run()

PrimeUI.clear(term)