import "../styles/globals.css";
import type { AppProps } from "next/app";
import { Footer } from "../components/Footer/index";
import { useRef } from "react";
import React, { createContext } from "react";

export interface IRefContext {
    targetRef: React.LegacyRef<HTMLDivElement>;
}

export const RefContext = createContext({} as IRefContext);

function MyApp({ Component, pageProps }: AppProps) {
    const targetRef = useRef() as React.MutableRefObject<HTMLInputElement>;;

    return (
        <>
            <RefContext.Provider value={{ targetRef }}>
                <Component {...pageProps} />
                <Footer targetRef={targetRef} />
            </RefContext.Provider>
        </>
    );
}

export default MyApp;
