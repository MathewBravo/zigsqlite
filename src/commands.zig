const std = @import("std");

const MetaCommandResult = enum {
    META_COMMAND_SUCCESS,
    META_COMMAND_UNRECOGNIZED_COMMAND,
};

const PrepareResult = enum {
    PREPARE_SUCCESS,
    PREPARE_UNRECOGNIZED_STATEMENT,
};

const StatementType = enum {
    STATEMENT_UNINITIALIZED,
    STATEMENT_INSERT,
    STATEMENT_SELECT,
};

const Statement = struct {
    type: StatementType,
};

pub fn command_handler(user_input: []u8) !void {
    var met_command_res: MetaCommandResult = undefined;
    if (user_input.len > 0 and user_input[0] == '.') {
        met_command_res = execute_meta_command(user_input);
    } else {
        met_command_res = MetaCommandResult.META_COMMAND_UNRECOGNIZED_COMMAND;
    }

    var statement = Statement{
        .type = StatementType.STATEMENT_UNINITIALIZED,
    };
    switch (prepare_statement(user_input, &statement)) {
        PrepareResult.PREPARE_SUCCESS => {},
        PrepareResult.PREPARE_UNRECOGNIZED_STATEMENT => std.debug.print("Unrecognized Statement: {s}", .{user_input}),
    }

    execute_statement(&statement);
    std.debug.print("Executed.\n", .{});
}

fn execute_meta_command(command: []u8) MetaCommandResult {
    if (std.mem.eql(u8, command, ".exit")) {
        std.process.exit(0);
    } else {
        return MetaCommandResult.META_COMMAND_UNRECOGNIZED_COMMAND;
    }
}

fn prepare_statement(user_input: []u8, statement: *Statement) PrepareResult {
    if (std.mem.eql(u8, user_input[0..6], "insert")) {
        statement.type = StatementType.STATEMENT_INSERT;
        return PrepareResult.PREPARE_SUCCESS;
    }

    if (std.mem.eql(u8, user_input[0..6], "select")) {
        statement.type = StatementType.STATEMENT_SELECT;
        return PrepareResult.PREPARE_SUCCESS;
    }

    return PrepareResult.PREPARE_UNRECOGNIZED_STATEMENT;
}

fn execute_statement(statement: *Statement) void {
    switch (statement.type) {
        StatementType.STATEMENT_INSERT => {
            std.debug.print("This is where we insert\n", .{});
        },
        StatementType.STATEMENT_SELECT => {
            std.debug.print("This is where we select\n", .{});
        },
        StatementType.STATEMENT_UNINITIALIZED => {
            std.debug.print("Unit Statement should now have reached this far\n", .{});
        },
    }
}
