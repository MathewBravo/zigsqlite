const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        var buffer: [1024]u8 = undefined;
        print_prompt();
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');

        const trimmed_input = std.mem.trimRight(u8, user_input, "\r\n");

        if (std.mem.eql(u8, trimmed_input, "exit")) {
            std.process.exit(0);
        } else {
            try stdout.print("You entered: {s}\n", .{user_input});
        }
    }
}

fn print_prompt() void {
    std.debug.print("> ", .{});
}
