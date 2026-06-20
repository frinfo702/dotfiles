local festival_emojis = {
  "🎉", "🎊", "🎆", "🎇", "✨", "🎵", "🎶", "💃", "🕺",
  "🎪", "🎠", "🎡", "🎢", "🎨", "🎭", "🎸", "🎺", "🎷",
  "🎻", "🥁", "🎪", "🎀", "🎁", "🎈", "💥", "🔥", "🌟",
  "🌈", "⭐", "🎵", "🎶", "🎤", "🎬", "🏮", "🎊", "🎉",
}

local function rand_int(min, max)
  return math.floor(math.random() * (max - min + 1)) + min
end

local function fireworks()
  local particles = {}
  local cols = vim.o.columns
  local rows = vim.o.lines - 1
  local num_particles = rand_int(20, 40)

  for _ = 1, num_particles do
    local emoji = festival_emojis[rand_int(1, #festival_emojis)]
    local col = rand_int(2, cols - 2)
    table.insert(particles, {
      win_id = nil,
      row = rows - 1,
      col = col,
      vel_row = -(3 + math.random() * 6),
      vel_col = (math.random() - 0.5) * 4,
      opacity = 1.0,
      emoji = emoji,
      lifetime = 0,
      max_lifetime = 30 + rand_int(0, 20),
    })
  end

  local function animate()
    local any_alive = false

    for _, p in ipairs(particles) do
      p.lifetime = p.lifetime + 1

      if p.lifetime > p.max_lifetime then
        p.opacity = p.opacity - 0.08
      end

      p.row = p.row + p.vel_row * 0.3
      p.vel_row = p.vel_row + 0.08
      p.col = p.col + p.vel_col * 0.3

      local r = math.floor(p.row + 0.5)
      local c = math.floor(p.col + 0.5)

      if r >= 1 and r <= rows - 1 and c >= 1 and c <= cols - 1 and p.opacity > 0 then
        any_alive = true
      elseif p.lifetime > 1 then
        if p.win_id and vim.api.nvim_win_is_valid(p.win_id) then
          vim.api.nvim_win_close(p.win_id, true)
          p.win_id = nil
        end
      end
    end

    if not any_alive then
      for _, p in ipairs(particles) do
        if p.win_id and vim.api.nvim_win_is_valid(p.win_id) then
          vim.api.nvim_win_close(p.win_id, true)
        end
      end
      return
    end

    for _, p in ipairs(particles) do
      local r = math.floor(p.row + 0.5)
      local c = math.floor(p.col + 0.5)

      if p.win_id and vim.api.nvim_win_is_valid(p.win_id) then
        vim.api.nvim_win_close(p.win_id, true)
        p.win_id = nil
      end

      if r >= 1 and r <= rows - 1 and c >= 1 and c <= cols - 1 and p.opacity > 0 and p.lifetime <= p.max_lifetime + 10 then
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { p.emoji })
        local win = vim.api.nvim_open_win(buf, false, {
          relative = "editor",
          width = 2,
          height = 1,
          row = r,
          col = c,
          style = "minimal",
          focusable = false,
        })
        vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
        vim.api.nvim_win_set_option(win, "conceallevel", 3)
        vim.api.nvim_win_set_option(win, "concealcursor", "n")
        p.win_id = win
      end
    end

    vim.defer_fn(animate, 60)
  end

  animate()
end

local function burst()
  for _ = 1, 3 do
    vim.defer_fn(function()
      fireworks()
    end, math.random() * 300)
  end
end

vim.api.nvim_create_user_command("Nigga", burst, {
  desc = "お祭り絵文字が飛び出る 🎉",
  range = false,
})
