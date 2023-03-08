import type { AppProps } from "next/app";
import React, { createContext, useRef } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import { ReactQueryDevtools } from "react-query/devtools";
import { Footer } from "../components/Footer/index";
import "../styles/globals.css";

export interface IRefContext {
    targetRef: React.LegacyRef<HTMLDivElement>;
}

export const RefContext = createContext({} as IRefContext);

const twentyFourHoursInMs = 1000 * 60 * 60 * 24;
export const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            refetchOnWindowFocus: false,
            refetchOnMount: false,
            refetchOnReconnect: false,
            retry: false,
            staleTime: twentyFourHoursInMs,
        },
    },
});

function MyApp({ Component, pageProps }: AppProps) {
    const targetRef = useRef() as React.MutableRefObject<HTMLInputElement>;

    return (
        <React.Fragment>
            <QueryClientProvider client={queryClient}>
                <RefContext.Provider value={{ targetRef }}>
                    <Component {...pageProps} />
                    <Footer targetRef={targetRef} />
                </RefContext.Provider>
                {process.env.NODE_ENV == "development" ? <ReactQueryDevtools initialIsOpen={false} /> : null}
            </QueryClientProvider>
        </React.Fragment>
    );
}

export default MyApp;
