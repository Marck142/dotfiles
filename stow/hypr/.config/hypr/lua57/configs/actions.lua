-- workspaceopt allfloat удалён upstream. Этот callback переключает
-- только существующие окна активного рабочего стола, не будущие окна.
local M = {}

function M.toggle_all_floating()
    local workspace = hl.get_active_workspace()
    if not workspace then return end
    local windows = hl.get_workspace_windows(workspace)
    if #windows == 0 then return end

    local all_floating = true
    for _, window in ipairs(windows) do
        if not window.floating then
            all_floating = false
            break
        end
    end

    -- Смешанный/тайловый рабочий стол: float всех; полностью floating: tile всех.
    local target_floating = not all_floating
    for _, window in ipairs(windows) do
        if window.floating ~= target_floating then
            hl.dispatch(hl.dsp.window.float({
                window = window,
                action = target_floating and "enable" or "disable",
            }))
        end
    end
end

return M
