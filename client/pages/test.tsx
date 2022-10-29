import "antd/dist/antd.css"; // or 'antd/dist/antd.less'
import { Button, DatePicker } from "antd";

const Test = () => {
    return (
        <>
            <Button type="primary">PRESS ME</Button>
            <DatePicker placeholder="select date" />
        </>
    );
};

export default Test;
