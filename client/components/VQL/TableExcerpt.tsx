export interface Cell {
    value: any;
}

export interface Row {
    cells: Cell[];
}

// This is for table exceprt
export interface Table {
    name: string;
    headers: string[];
    col_types: string[];
    allow_null: boolean;
    rows: Row[];
}
