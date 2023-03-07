import React, { useState, useEffect } from "react";
import { isMobile } from "react-device-detect";

export const Cursor = () => {
    const [position, setPosition] = useState({ x: 0, y: 0 });
    // const [hidden, setHidden] = useState(false);
    const [clicked, setClicked] = useState(false);
    const [linkHovered, setLinkHovered] = useState(false);

    const updateMousePosition = (e: MouseEvent) => {
        setPosition({ x: e.clientX, y: e.clientY });
    };
    useEffect(() => {
        console.log(`isMobile: ${isMobile}`);
        if (!isMobile) {
            console.log(`is not mobile`);
            // const updateMouseEnter = () => setHidden(false);
            // const updateMouseLeave = () => setHidden(true);
            const updateMouseDown = () => setClicked(true);
            const updateMouseUp = () => setClicked(false);
            const updateMouseOver = () => setLinkHovered(true);
            const updateLinkOut = () => setLinkHovered(false);
            const addEventListener = () => {
                document.addEventListener("mousemove", updateMousePosition);
                // document.addEventListener("mouseenter", updateMouseEnter);
                // document.addEventListener("mouseleave", updateMouseLeave);
                document.addEventListener("mousedown", updateMouseDown);
                document.addEventListener("mouseup", updateMouseUp);
                document.querySelectorAll(".table_sketch").forEach((el) => {
                    console.log(`found mouseover el: ${el}`);
                    el.addEventListener("mouseover", updateMouseOver);
                });
            };
            const removeEventListener = () => {
                document.removeEventListener("mousemove", updateMousePosition);
                // document.removeEventListener("mouseenter", updateMouseEnter);
                // document.removeEventListener("mouseleave", updateMouseLeave);
                document.removeEventListener("mousedown", updateMouseDown);
                document.removeEventListener("mouseup", updateMouseUp);
                document.querySelectorAll(".table_sketch").forEach((el) => {
                    console.log(`found mouseout el: ${el}`);
                    el.addEventListener("mouseout", updateLinkOut);
                });
            };
            addEventListener();
            return () => removeEventListener();
        }
    }, []);

    useEffect(() => {
        console.log(`linkHovered: ${linkHovered}`);
    }, [linkHovered]);

    return (
        <div
            className={
                "cursor" +
                // (hidden ? "c--hidden" : " ") +
                (clicked ? "c--clicked" : " ") +
                (linkHovered ? "c--hover" : " ")
            }
            style={{ left: `${position.x}px`, top: `${position.y}px` }}
        ></div>
    );
};

export default Cursor;
